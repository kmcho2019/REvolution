module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] current_state;
reg [2:0] previous_state;

// Encoding for states
parameter above_s2 = 3'b111;
parameter between_s2_s1 = 3'b011;
parameter between_s1_s0 = 3'b001;
parameter below_s0 = 3'b000;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        // Reset state machine to state equivalent to low water level
        current_state <= below_s0;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        previous_state <= current_state;
        case(s)
            3'b111: current_state <= above_s2;
            3'b011: current_state <= between_s2_s1;
            3'b001: current_state <= between_s1_s0;
            default: current_state <= below_s0;
        endcase
    end
end

always @(current_state or previous_state) begin
    case(current_state)
        above_s2: begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end
        between_s2_s1: begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            if(previous_state == between_s1_s0 || previous_state == below_s0) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end
        between_s1_s0: begin
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            if(previous_state == below_s0) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end
        below_s0: begin
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end
    endcase
end

endmodule
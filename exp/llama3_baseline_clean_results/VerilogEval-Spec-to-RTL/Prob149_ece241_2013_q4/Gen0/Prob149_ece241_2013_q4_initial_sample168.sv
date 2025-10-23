module TopModule (
    input clk,
    input reset,
    input [2:0] s,  // s[2] is the highest sensor, s[0] is the lowest sensor
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] current_state;
reg [2:0] next_state;

always @(*) begin
    case (current_state)
        3'b000: begin  // below s[0]
            if (s[0]) begin
                next_state = 3'b001;  // transition to between s[1] and s[0]
            end else begin
                next_state = 3'b000;  // stay in the same state
            end
        end
        3'b001: begin  // between s[1] and s[0]
            if (s[1]) begin
                next_state = 3'b010;  // transition to between s[2] and s[1]
            end else if (!s[0]) begin
                next_state = 3'b000;  // transition to below s[0]
            end else begin
                next_state = 3'b001;  // stay in the same state
            end
        end
        3'b010: begin  // between s[2] and s[1]
            if (s[2]) begin
                next_state = 3'b011;  // transition to above s[2]
            end else if (!s[1]) begin
                next_state = 3'b001;  // transition to between s[1] and s[0]
            end else begin
                next_state = 3'b010;  // stay in the same state
            end
        end
        3'b011: begin  // above s[2]
            if (!s[2]) begin
                next_state = 3'b010;  // transition to between s[2] and s[1]
            end else begin
                next_state = 3'b011;  // stay in the same state
            end
        end
        default: next_state = 3'b000;  // default state
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        current_state <= 3'b000;  // reset to the state equivalent to low water level
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        current_state <= next_state;
        case (next_state)
            3'b000: begin  // below s[0]
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
            3'b001: begin  // between s[1] and s[0]
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                if (current_state == 3'b000) begin  // water level is rising
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            3'b010: begin  // between s[2] and s[1]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                if (current_state == 3'b001) begin  // water level is rising
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            3'b011: begin  // above s[2]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
        endcase
    end
end

endmodule
module TopModule(
    input  clk,
    input  reset,
    input  [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] prev_s; // previous sensor state
reg [2:0] curr_s; // current sensor state
reg       increase; // flag to indicate if water level is increasing

always @(posedge clk or posedge reset) begin
    if(reset) begin
        // reset state machine to a state equivalent to if the water level had been low for a long time
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        curr_s <= s;
        if(curr_s > prev_s) begin
            increase <= 1'b1;
        end else begin
            increase <= 1'b0;
        end
        prev_s <= curr_s;

        // determine output flow rate based on current state and previous state
        case (curr_s)
            3'b000: begin // below s[0]
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
            3'b001: begin // between s[1] and s[0]
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= increase;
            end
            3'b011: begin // between s[2] and s[1]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= increase;
            end
            3'b111: begin // above s[2]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            default: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
        endcase
    end
end

endmodule
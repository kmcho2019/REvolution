module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot state encoding
    localparam [3:0] STATE_A = 4'b0001,
                     STATE_B = 4'b0010,
                     STATE_C = 4'b0100,
                     STATE_D = 4'b1000;

    reg [3:0] state;

    // Combined state transition and output logic
    always @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
        end
        else begin
            casez (state)
                STATE_A: begin
                    casez (r)
                        3'b1??: state <= STATE_B;  // r[0] has priority
                        3'b01?: state <= STATE_C;   // then r[1]
                        3'b001: state <= STATE_D;   // then r[2]
                        default: state <= STATE_A;  // no requests
                    endcase
                end
                STATE_B: state <= r[0] ? STATE_B : STATE_A;
                STATE_C: state <= r[1] ? STATE_C : STATE_A;
                STATE_D: state <= r[2] ? STATE_D : STATE_A;
                default: state <= STATE_A;  // recovery from bad states
            endcase
        end
    end

    // Output assignments (direct from state bits)
    assign g[0] = state[1];  // STATE_B
    assign g[1] = state[2];  // STATE_C
    assign g[2] = state[3];  // STATE_D

endmodule
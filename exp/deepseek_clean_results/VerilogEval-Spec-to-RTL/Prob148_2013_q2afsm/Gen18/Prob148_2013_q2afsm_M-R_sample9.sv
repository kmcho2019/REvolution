module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // One-hot state encoding
    localparam [3:0] A = 4'b0001,
                     B = 4'b0010,
                     C = 4'b0100,
                     D = 4'b1000;

    reg [3:0] state;

    // Combined state transition and output logic
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            g <= 3'b000;
        end else begin
            case (1'b1) // synthesis parallel_case
                state[A]: begin
                    if (r[0]) begin
                        state <= B;
                        g <= 3'b001;
                    end else if (r[1]) begin
                        state <= C;
                        g <= 3'b010;
                    end else if (r[2]) begin
                        state <= D;
                        g <= 3'b100;
                    end else begin
                        state <= A;
                        g <= 3'b000;
                    end
                end
                state[B]: begin
                    if (r[0]) begin
                        state <= B;
                        g <= 3'b001;
                    end else begin
                        state <= A;
                        g <= 3'b000;
                    end
                end
                state[C]: begin
                    if (r[1]) begin
                        state <= C;
                        g <= 3'b010;
                    end else begin
                        state <= A;
                        g <= 3'b000;
                    end
                end
                state[D]: begin
                    if (r[2]) begin
                        state <= D;
                        g <= 3'b100;
                    end else begin
                        state <= A;
                        g <= 3'b000;
                    end
                end
                default: begin
                    state <= A;
                    g <= 3'b000;
                end
            endcase
        end
    end

endmodule
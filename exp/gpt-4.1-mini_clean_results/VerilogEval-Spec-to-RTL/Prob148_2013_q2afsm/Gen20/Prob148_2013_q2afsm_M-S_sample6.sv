module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // State encoding (2 bits)
    // 2'b00 = A (idle, no grant)
    // 2'b01 = B (grant device 0)
    // 2'b10 = C (grant device 1)
    // 2'b11 = D (grant device 2)
    reg [1:0] state;

    always @(posedge clk) begin
        if (~resetn) begin
            state <= 2'b00;
            g <= 3'b000;
        end else begin
            case (state)
                2'b00: begin // A (idle)
                    if (r[0]) begin
                        state <= 2'b01; // grant device 0
                        g <= 3'b001;
                    end else if (r[1]) begin
                        state <= 2'b10; // grant device 1
                        g <= 3'b010;
                    end else if (r[2]) begin
                        state <= 2'b11; // grant device 2
                        g <= 3'b100;
                    end else begin
                        state <= 2'b00;
                        g <= 3'b000;
                    end
                end
                2'b01: begin // B (grant device 0)
                    if (r[0]) begin
                        state <= 2'b01;
                        g <= 3'b001;
                    end else begin
                        state <= 2'b00;
                        g <= 3'b000;
                    end
                end
                2'b10: begin // C (grant device 1)
                    if (r[1]) begin
                        state <= 2'b10;
                        g <= 3'b010;
                    end else begin
                        state <= 2'b00;
                        g <= 3'b000;
                    end
                end
                2'b11: begin // D (grant device 2)
                    if (r[2]) begin
                        state <= 2'b11;
                        g <= 3'b100;
                    end else begin
                        state <= 2'b00;
                        g <= 3'b000;
                    end
                end
                default: begin
                    state <= 2'b00;
                    g <= 3'b000;
                end
            endcase
        end
    end

endmodule
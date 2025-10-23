module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // State encoding
    localparam A  = 2'b00;
    localparam G0 = 2'b01;
    localparam G1 = 2'b10;
    localparam G2 = 2'b11;

    reg [1:0] state;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            g <= 3'b000;
        end else begin
            case (state)
                A: begin
                    if (r[0]) begin
                        state <= G0;
                        g <= 3'b001;
                    end else if (r[1]) begin
                        state <= G1;
                        g <= 3'b010;
                    end else if (r[2]) begin
                        state <= G2;
                        g <= 3'b100;
                    end else begin
                        state <= A;
                        g <= 3'b000;
                    end
                end
                G0: begin
                    if (r[0]) begin
                        state <= G0;
                        g <= 3'b001;
                    end else begin
                        state <= A;
                        g <= 3'b000;
                    end
                end
                G1: begin
                    if (r[1]) begin
                        state <= G1;
                        g <= 3'b010;
                    end else begin
                        state <= A;
                        g <= 3'b000;
                    end
                end
                G2: begin
                    if (r[2]) begin
                        state <= G2;
                        g <= 3'b100;
                    end else begin
                        state <= A;
                        g <= 3'b000;
                    end
                end
            endcase
        end
    end

endmodule
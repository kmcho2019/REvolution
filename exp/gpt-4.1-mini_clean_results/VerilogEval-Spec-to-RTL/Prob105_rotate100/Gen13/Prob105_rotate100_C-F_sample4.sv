module TopModule (
    input          clk,
    input          load,
    input   [1:0]  ena,
    input   [99:0] data,
    output  reg [99:0] q
);

    reg [99:0] next_q;
    integer i;

    // Combinational logic to calculate next_q based on load and ena
    always @* begin
        if (load) begin
            // Load data synchronously
            next_q = data;
        end else begin
            case (ena)
                2'b01: begin
                    // Rotate right by one bit:
                    // q[i] = q[(i+1) mod 100]
                    for (i = 0; i < 100; i = i + 1) begin
                        if (i == 99)
                            next_q[i] = q[0];
                        else
                            next_q[i] = q[i + 1];
                    end
                end
                2'b10: begin
                    // Rotate left by one bit:
                    // q[i] = q[(i-1 + 100) mod 100]
                    for (i = 0; i < 100; i = i + 1) begin
                        if (i == 0)
                            next_q[i] = q[99];
                        else
                            next_q[i] = q[i - 1];
                    end
                end
                default: begin
                    // No rotation, hold current value
                    next_q = q;
                end
            endcase
        end
    end

    // Sequential update on rising edge of clk
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule
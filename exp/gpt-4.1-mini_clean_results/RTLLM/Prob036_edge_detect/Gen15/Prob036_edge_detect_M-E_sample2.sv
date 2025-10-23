module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_d1, a_d2;

    // Two-stage shift register to delay 'a' signal
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_d1 <= 1'b0;
            a_d2 <= 1'b0;
        end else begin
            a_d1 <= a;
            a_d2 <= a_d1;
        end
    end

    // Detect edges based on delayed samples and register outputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= (~a_d2) & a_d1;  // 0->1 transition
            down <= a_d2 & (~a_d1);  // 1->0 transition
        end
    end

endmodule
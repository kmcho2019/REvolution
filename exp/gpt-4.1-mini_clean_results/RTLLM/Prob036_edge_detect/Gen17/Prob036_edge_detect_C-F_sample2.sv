module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_1d;
    reg rise_reg, down_reg;
    wire rise_w, down_w;

    // Register input 'a'
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_1d <= 1'b0;
        else
            a_1d <= a;
    end

    // Combinational edge detection signals
    assign rise_w = (~a_1d) & a;  // rising edge: previous 0, current 1
    assign down_w = a_1d & (~a);  // falling edge: previous 1, current 0

    // Register outputs to hold edge detection high for one full clock cycle
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise_reg <= 1'b0;
            down_reg <= 1'b0;
        end else begin
            rise_reg <= rise_w;
            down_reg <= down_w;
        end
    end

    // Drive outputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= rise_reg;
            down <= down_reg;
        end
    end

endmodule
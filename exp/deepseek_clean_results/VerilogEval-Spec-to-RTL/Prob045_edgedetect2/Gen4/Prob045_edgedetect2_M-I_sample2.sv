module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    reg [7:0] edge_detect;
    reg enable;

    // Enable generation - reduces power when inputs are stable
    always @(posedge clk) begin
        enable <= (in != prev_in);
        prev_in <= in;
    end

    // Pipelined edge detection
    always @(posedge clk) begin
        if (enable) begin
            edge_detect <= in ^ prev_in;
            anyedge <= edge_detect;
        end else begin
            edge_detect <= 8'b0;
            anyedge <= 8'b0;
        end
    end

endmodule
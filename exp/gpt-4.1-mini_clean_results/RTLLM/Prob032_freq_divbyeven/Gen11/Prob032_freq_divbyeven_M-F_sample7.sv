module freq_divbyeven #(
    parameter integer NUM_DIV = 4  // Must be an even number
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    reg [3:0] cnt;
    wire count_max_reached;

    // Combinational signal indicating counter reached half period - 1
    assign count_max_reached = (cnt == (NUM_DIV/2 - 1));

    // Optional synthesis-time check (commented):
    // initial begin
    //     if (NUM_DIV % 2 != 0) begin
    //         $error("NUM_DIV parameter must be an even number.");
    //     end
    // end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 4'd0;
            clk_div <= 1'b0;
        end else begin
            if (count_max_reached) begin
                cnt     <= 4'd0;
                clk_div <= ~clk_div; // toggle output clock
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

endmodule
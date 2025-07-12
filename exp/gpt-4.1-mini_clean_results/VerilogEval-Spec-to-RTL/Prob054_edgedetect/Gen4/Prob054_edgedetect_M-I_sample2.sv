module TopModule (
    input        clk,
    input        rst_n,    // Active low asynchronous reset added for robustness
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            prev_in <= 8'b0;
            pedge   <= 8'b0;
        end else begin
            pedge   <= (~prev_in) & in;  // detect rising edges based on prev_in before update
            prev_in <= in;               // update prev_in with current input
        end
    end

endmodule
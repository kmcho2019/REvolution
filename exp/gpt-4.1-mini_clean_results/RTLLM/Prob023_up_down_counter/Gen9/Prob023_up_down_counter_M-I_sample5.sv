module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

    wire [15:0] next_count;

    // next_count is count plus or minus 1 depending on up_down
    assign next_count = count + (up_down ? 16'd1 : 16'hFFFF); // Adding -1 as 16'hFFFF

    always @(posedge clk) begin
        if (reset)
            count <= 16'd0;
        else
            count <= next_count;
    end

endmodule
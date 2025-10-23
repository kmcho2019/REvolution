module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

    wire [15:0] next_count;

    assign next_count = reset ? 16'd0 :
                        (up_down ? count + 16'd1 : count - 16'd1);

    always @(posedge clk) begin
        count <= next_count;
    end

endmodule
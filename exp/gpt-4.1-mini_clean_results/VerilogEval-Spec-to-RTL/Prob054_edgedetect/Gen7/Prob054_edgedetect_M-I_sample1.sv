module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect;

    // Combinational edge detection based on prev_in and current in
    assign edge_detect = (~prev_in) & in;

    always @(posedge clk) begin
        // Update pedge register to reflect edges detected in previous cycle
        pedge <= edge_detect;
        // Update prev_in only if input changes, to reduce toggling
        if (prev_in != in)
            prev_in <= in;
    end

endmodule
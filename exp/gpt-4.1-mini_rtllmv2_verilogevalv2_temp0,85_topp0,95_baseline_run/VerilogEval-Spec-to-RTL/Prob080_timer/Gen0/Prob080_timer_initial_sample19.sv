// D flip-flop module with synchronous reset (not needed here but general)
module DFF (
    input wire clk,
    input wire d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module TopModule(
    input wire clk,
    input wire load,
    input wire [9:0] data,
    output wire tc
);

    reg [9:0] counter;
    wire tc_next;

    // Determine next tc value (1 if counter==0)
    assign tc_next = (counter == 10'd0) ? 1'b1 : 1'b0;

    // Counter update
    always @(posedge clk) begin
        if (load) begin
            counter <= data;
        end else if (counter != 10'd0) begin
            counter <= counter - 10'd1;
        end else begin
            counter <= counter; // hold zero
        end
    end

    // Single D flip-flop to register the tc output
    wire tc_reg;
    DFF dff_tc (
        .clk(clk),
        .d(tc_next),
        .q(tc_reg)
    );

    assign tc = tc_reg;

endmodule
module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    reg [7:0] not_prev_in /* synthesis keep */;
    wire [7:0] edge_detect;
    wire input_changed = (in != prev_in);

    // Pipelined edge detection
    always @(posedge clk) begin
        if (input_changed) begin
            not_prev_in <= ~prev_in;
            prev_in <= in;
        end
    end

    // Second pipeline stage
    assign edge_detect = in & not_prev_in;

    // Output register with enable
    always @(posedge clk) begin
        if (input_changed) begin
            pedge <= edge_detect;
        end else begin
            pedge <= 8'b0;
        end
    end

endmodule
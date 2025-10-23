module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect;
    wire       prev_in_en;
    wire       pedge_en;

    // Combinational edge detection: bits that transitioned from 0 to 1
    assign edge_detect = (~prev_in) & in;

    // Enable signal to update prev_in only if input changes to reduce toggling
    assign prev_in_en = (in != prev_in);

    // Enable signal to update pedge only if edge_detect is non-zero
    assign pedge_en = |edge_detect;

    // Register previous input only when input changes
    always @(posedge clk) begin
        if (prev_in_en)
            prev_in <= in;
    end

    // Register output pulses one cycle after edge detection only when edges detected
    always @(posedge clk) begin
        if (pedge_en)
            pedge <= edge_detect;
        else
            pedge <= 8'b0;
    end

endmodule
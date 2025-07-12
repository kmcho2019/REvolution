module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire counter_nonzero = (counter != 10'd0);
    wire ce = load | counter_nonzero;  // clock enable signal

    always @(posedge clk) begin
        if (ce) begin
            if (load) begin
                counter <= data;
            end else if (counter_nonzero) begin
                counter <= counter - 10'd1;
            end else begin
                counter <= 10'd0; // Hold zero explicitly, though this path rarely triggers due to ce gating
            end
        end
        // else hold the current value (no toggling)
    end

    assign tc = (counter == 10'd0);

endmodule
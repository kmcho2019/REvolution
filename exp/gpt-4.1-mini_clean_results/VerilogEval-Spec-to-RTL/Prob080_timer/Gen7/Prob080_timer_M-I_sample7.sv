module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire counter_nonzero = (counter != 10'd0);
    wire ce = load | counter_nonzero;  // clock enable signal

    // On clock edge, update counter only when enabled
    always @(posedge clk) begin
        if (ce) begin
            if (load) begin
                counter <= data;
            end else begin
                counter <= counter - 10'd1;
            end
        end
        // else hold counter value (no state change)
    end

    assign tc = (counter == 10'd0);

endmodule
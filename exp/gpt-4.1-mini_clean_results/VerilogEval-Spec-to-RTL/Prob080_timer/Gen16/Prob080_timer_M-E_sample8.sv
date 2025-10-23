module TopModule (
    input        clk,
    input        load,
    input [9:0]  data,
    output       tc
);

reg [9:0] counter;
reg       running; // single D flip-flop to indicate timer is active

always @(posedge clk) begin
    if (load) begin
        counter <= data;
        running <= 1'b1; // start counting
    end
    else if (running) begin
        if (counter != 10'd0)
            counter <= counter - 10'd1;
        if (counter == 10'd1)
            running <= 1'b0; // stop counting at zero next cycle
    end
end

assign tc = (counter == 10'd0) && (running == 1'b0);

endmodule
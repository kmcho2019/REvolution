module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    reg active;  // Indicates if countdown is active

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
            active <= (data != 0);
        end else if (active) begin
            if (counter != 0)
                counter <= counter - 1;
            if (counter == 1)
                active <= 0;  // Stop counting next cycle as we reach zero
        end
    end

    assign tc = (counter == 0);

endmodule
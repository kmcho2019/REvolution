module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

    reg [9:0] counter;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
            tc <= 0;
        end else begin
            if (counter != 0)
                counter <= counter - 1;
            if (counter == 1) // next decrement will reach 0
                tc <= 1;
        end
    end

endmodule
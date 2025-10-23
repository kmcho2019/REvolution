module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [1:0] counter;
    reg [3:0] circular_buffer;

    always @(posedge clk) begin
        if (!resetn) begin
            counter <= 2'b00;
            circular_buffer <= 4'b0000;
        end
        else begin
            circular_buffer[counter] <= in;
            counter <= counter + 1;
        end
    end

    // Output is the value at (counter - 1) mod 4
    assign out = circular_buffer[(counter - 1)];

endmodule
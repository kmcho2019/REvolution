module TopModule (
    input       clk,
    input       resetn,
    input       in,
    output      out
);

reg [3:0] data;
reg [1:0] counter; // To keep track of the current bit position

always_ff @(posedge clk) begin
    if (!resetn) begin
        data <= 4'b0000;
        counter <= 2'b00;
    end else begin
        // Use a counter to determine which bit to shift in
        case (counter)
            2'b00: data[0] <= in;
            2'b01: data[1] <= data[0];
            2'b10: data[2] <= data[1];
            2'b11: data[3] <= data[2];
        endcase
        // Increment the counter, wrapping around after 3
        if (counter == 2'b11) begin
            counter <= 2'b00;
        end else begin
            counter <= counter + 1'b1;
        end
    end
end

assign out = data[3];

endmodule
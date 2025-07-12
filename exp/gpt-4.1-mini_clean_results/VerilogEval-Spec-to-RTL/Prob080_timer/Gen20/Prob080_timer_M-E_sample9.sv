module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);
    reg [9:0] shift_reg; // one-hot encoding of countdown position

    wire [9:0] load_pattern;
    integer i;

    // Generate one-hot load pattern with '1' at data-1 position (if data != 0)
    // If data=0, no count, shift_reg=0 means tc asserted immediately
    always @(*) begin
        load_pattern = 10'b0;
        if (data != 0) begin
            load_pattern = 10'b0;
            // place 1 at bit position (data-1) counting from MSB=bit9 down to LSB=bit0
            // Since data is 1 to 1023, but our width is 10, clamp to 10
            // For counts >10, treat as full count (bit9)
            // For data <=10, set corresponding bit: bit (10 - data)
            if (data > 10)
                load_pattern = 10'b1000000000; // max count position
            else begin
                // bit position to set is (10 - data)
                load_pattern = 10'b0;
                load_pattern[10 - data] = 1'b1;
            end
        end
    end

    wire shift_done = (shift_reg[9] == 1'b0 && shift_reg[8:0] == 9'b0);

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= load_pattern;
        end else if (!shift_done) begin
            // Shift right by one (towards LSB)
            shift_reg <= shift_reg >> 1;
        end else begin
            // Stay at zero when done
            shift_reg <= 10'b0;
        end
    end

    assign tc = shift_done;

endmodule
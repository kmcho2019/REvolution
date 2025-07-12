module TopModule(
    input  clk,
    input  areset,
    input  x,
    output reg z
);

reg [31:0] shift_reg; // 32-bit shift register
reg [4:0] count; // count of input bits
reg started;

// state machine
always @ (posedge clk or posedge areset) begin
    if(areset) begin
        shift_reg <= 32'b0; // reset shift register
        count <= 5'b0; // reset count
        started <= 1'b0; // reset started flag
    end else begin
        if(!started) begin
            if(x) begin
                shift_reg <= {31'b0, x}; // shift in first bit
                count <= 5'b1; // increment count
                started <= 1'b1; // set started flag
            end
        end else begin
            shift_reg <= {shift_reg[30:0], x}; // shift in next bit
            count <= count + 1'b1; // increment count
        end
    end
end

// output logic
always @ (*) begin
    if(!started) begin
        z = 1'b0; // output 0 when idle
    end else begin
        // calculate 2's complement
        reg [31:0] temp;
        temp = ~(shift_reg) + 1'b1;
        z = temp[31 - count]; // output current bit
    end
end

endmodule
module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

logic [7:0] shift_reg [2:0]; // Shift register to store incoming bytes
logic [1:0] byte_count; // Counter to track number of bytes received

always_ff @(posedge clk) begin
    if(reset) begin
        byte_count <= 2'b00;
        for (int i = 0; i < 3; i++) begin
            shift_reg[i] <= 8'b0;
        end
    end
    else begin
        // Shift incoming byte into shift register
        for (int i = 2; i > 0; i--) begin
            shift_reg[i] <= shift_reg[i-1];
        end
        shift_reg[0] <= in;

        // Check if incoming byte has in[3] = 1
        if(in[3]) begin
            byte_count <= 2'b01; // Reset counter and set to 1
        end
        else if(byte_count != 2'b00) begin
            byte_count <= byte_count + 1'b1; // Increment counter
        end
    end
end

assign done = (byte_count == 2'b11); // Assert 'done' signal when counter reaches 3

endmodule
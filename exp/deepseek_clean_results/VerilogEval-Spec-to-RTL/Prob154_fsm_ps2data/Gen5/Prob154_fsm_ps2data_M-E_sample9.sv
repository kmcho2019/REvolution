module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output done
);

    reg [1:0] byte_counter;
    reg [23:0] shift_reg;
    
    // Combinatorial done signal
    assign done = (byte_counter == 2'b11);

    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 2'b00;
            // Don't care about shift_reg contents on reset
        end else begin
            if (byte_counter == 2'b00) begin
                // Waiting for start byte
                if (in[3]) begin
                    shift_reg <= {in, 16'b0};
                    byte_counter <= 2'b01;
                end
            end else begin
                // Shift in new byte
                shift_reg <= {shift_reg[15:0], in};
                
                // Increment counter or reset
                if (byte_counter == 2'b10) begin
                    byte_counter <= 2'b00;
                end else begin
                    byte_counter <= byte_counter + 1;
                end
            end
        end
    end

    // Output is valid only when done is asserted
    assign out_bytes = done ? shift_reg : 24'bz;

endmodule
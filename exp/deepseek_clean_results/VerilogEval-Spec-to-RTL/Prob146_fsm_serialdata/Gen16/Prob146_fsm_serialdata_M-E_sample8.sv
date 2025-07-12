module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    reg [3:0] counter;  // Counts 0-10 (start + 8 data + stop)
    reg [7:0] shift_reg;
    wire receiving = (counter > 0) && (counter < 9);
    wire valid_stop = (counter == 9) && in;
    wire valid_start = (counter == 0) && !in;

    // Combinatorial done signal
    assign done = (counter == 9) && in;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 4'd0;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
        end else begin
            // Protocol violation handling
            if ((counter == 0 && !valid_start) || 
                (counter == 9 && !valid_stop)) begin
                counter <= 4'd0;
            end
            // Normal operation
            else if (counter < 10) begin
                counter <= counter + 1;
            end else begin
                counter <= 4'd0;
            end

            // Data shifting
            if (receiving) begin
                shift_reg <= {in, shift_reg[7:1]};  // LSB first
            end

            // Parallel load when done
            if (done) begin
                out_byte <= shift_reg;
            end
        end
    end

endmodule
module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

reg [1:0] counter; // Counter to track the number of bytes received
reg processing; // Flag to indicate whether we're processing a message
reg prev_in3; // Register to store the value of in[3] from the previous cycle

always @(posedge clk) begin
    if (reset) begin
        counter <= 0;
        processing <= 0;
        prev_in3 <= 0;
        done <= 0;
    end else begin
        if (processing) begin
            counter <= counter + 1;
            if (counter == 3) begin
                processing <= 0;
                counter <= 0;
                done <= 1'b1; // Signal done after receiving third byte
            end
        end else if (in[3] == 1'b1 && prev_in3 == 1'b0) begin
            processing <= 1'b1;
            counter <= 1; // Start processing a new message
        end
        prev_in3 <= in[3];
    end
end

// Note: The done signal is asserted for only one clock cycle. If you want it to stay high until the next message is processed, 
// you can use a separate always block or a combinational logic to set done to 0 when processing is high and counter is not 3.

endmodule
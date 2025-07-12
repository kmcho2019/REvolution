module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

    reg [1:0] counter;
    reg [23:0] message_buffer;

    // Counter logic
    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'b00;
        end else begin
            if (counter == 2'b00) begin
                // Wait for start byte (in[3] == 1)
                if (in[3]) begin
                    counter <= 2'b01;
                end
            end else if (counter == 2'b11) begin
                // Reset after 3 bytes
                counter <= 2'b00;
            end else begin
                // Increment for next byte
                counter <= counter + 1;
            end
        end
    end

    // Message buffer update
    always @(posedge clk) begin
        if (!reset && counter != 2'b00) begin
            case (counter)
                2'b01: message_buffer[23:16] <= in;
                2'b10: message_buffer[15:8] <= in;
                2'b11: message_buffer[7:0] <= in;
            endcase
        end
    end

    // Output assignments
    assign out_bytes = (counter == 2'b11) ? message_buffer : 24'hx;
    assign done = (counter == 2'b11);

endmodule
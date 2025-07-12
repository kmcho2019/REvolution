module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;       // Binary counter (0-3)
    reg [3:0] shift_reg; // Shift register for serial output
    reg load;            // Load control signal

    // Counter and shift register logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b0;
            shift_reg <= 4'b0;
            load <= 1'b0;
        end else begin
            if (cnt == 2'b11) begin
                cnt <= 2'b0;
                shift_reg <= d;    // Load new parallel data
                load <= 1'b1;      // Signal new data loaded
            end else begin
                cnt <= cnt + 1'b1;
                shift_reg <= {shift_reg[2:0], 1'b0}; // Shift left
                load <= 1'b0;
            end
        end
    end

    // Output assignments
    assign dout = shift_reg[3];    // Always output MSB
    assign valid_out = load;       // Valid when new data loaded

endmodule
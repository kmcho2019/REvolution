module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] current_data;  // Holds the current 4-bit word being serialized
    reg [3:0] next_data;     // Buffers the next 4-bit word
    reg [1:0] ptr;           // Circular pointer (0-3)
    reg load_strobe;         // Indicates when to load new data

    // Predictive counter logic
    wire [1:0] next_ptr = ptr + 1'b1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_data <= 4'b0;
            next_data <= 4'b0;
            ptr <= 2'b11;     // Initialize to point to last bit
            load_strobe <= 1'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            // Update pointer and load control
            ptr <= next_ptr;
            load_strobe <= (next_ptr == 2'b00);

            // Data pipeline management
            if (load_strobe) begin
                current_data <= next_data;
                next_data <= d;
            end

            // Output generation
            dout <= current_data[ptr];
            valid_out <= (next_ptr == 2'b00);  // Early valid signal
        end
    end

endmodule
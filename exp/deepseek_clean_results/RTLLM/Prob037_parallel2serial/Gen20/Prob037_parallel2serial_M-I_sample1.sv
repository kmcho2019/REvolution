module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output wire dout
);

    reg [3:0] state;        // One-hot state (0001, 0010, 0100, 1000)
    reg [3:0] data;         // Shift register (circular)
    wire load_en;           // Parallel load enable

    // Output assignments
    assign dout = data[3];  // Always output MSB
    assign load_en = state[3]; // Load when in last state

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 4'b0001;
            data <= 4'b0000;
            valid_out <= 1'b0;
        end else begin
            // State transition (circular one-hot)
            state <= {state[2:0], state[3]};
            
            // Data handling with clock gating
            if (load_en) begin
                data <= d;          // Parallel load
                valid_out <= 1'b1;  // Valid when loading new data
            end else begin
                data <= {data[2:0], data[3]}; // Circular shift
                valid_out <= 1'b0;
            end
        end
    end

endmodule
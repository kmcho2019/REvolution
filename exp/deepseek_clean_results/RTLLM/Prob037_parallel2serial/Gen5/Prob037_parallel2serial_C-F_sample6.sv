module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] shift_reg;
    reg [3:0] state;  // One-hot state: 0001, 0010, 0100, 1000
    wire load_new = state[3];  // Detect last state

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            state <= 4'b0001;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            if (load_new) begin
                // Load new parallel data
                shift_reg <= d;
                state <= 4'b0001;
                valid_out <= 1'b1;
                dout <= d[3];  // Output MSB immediately
            end else begin
                // Rotate state and shift data
                state <= {state[2:0], state[3]};
                
                // Shift operation only when needed
                if (|state[2:0]) begin  // Only shift when not in load state
                    shift_reg <= {shift_reg[2:0], 1'b0};
                    dout <= shift_reg[2];  // Next bit
                end
                
                valid_out <= 1'b0;
            end
        end
    end

endmodule
module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    // One-hot encoded state machine (4 states)
    reg [3:0] state;
    reg [3:0] data;
    reg [1:0] ptr;      // Circular buffer pointer
    
    // Next state and output logic
    wire [3:0] next_state = {state[2:0], state[3]};
    assign dout = data[3-ptr];  // MSB first output
    assign valid_out = state[0]; // Valid on first state
    
    // Clock gating control
    wire shift_en = |state[2:0]; // Enable shift for states 1-3
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 4'b0001;    // Start in state 0
            data <= 4'b0;
            ptr <= 2'b0;
        end else begin
            state <= next_state;
            
            // Load new data when returning to state 0
            if (state[3]) begin
                data <= d;
                ptr <= 2'b0;
            end
            // Update pointer when shifting
            else if (shift_en) begin
                ptr <= ptr + 1'b1;
            end
        end
    end

endmodule
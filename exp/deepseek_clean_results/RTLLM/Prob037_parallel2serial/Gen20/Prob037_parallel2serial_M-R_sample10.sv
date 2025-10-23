module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    // One-hot encoded states
    localparam [3:0] 
        S_LOAD = 4'b0001,
        S_BIT1 = 4'b0010,
        S_BIT2 = 4'b0100,
        S_BIT3 = 4'b1000;

    reg [3:0] state;
    reg [3:0] data;

    // Next state logic
    wire [3:0] next_state;
    assign next_state = {state[2:0], state[3]}; // Circular shift left

    // Output assignments
    assign dout = data[3];
    assign valid_out = (state == S_LOAD);

    // State transition and data handling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_LOAD;
            data <= 4'b0000;
        end else begin
            state <= next_state;
            
            if (state == S_LOAD) begin
                data <= d;  // Parallel load
            end else begin
                data <= {data[2:0], 1'b0};  // Shift left
            end
        end
    end

endmodule
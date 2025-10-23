module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Define the states of the FSM
enum logic [1:0] {S0, S1, S2, S3} state, next_state;

// Data register to store the parallel input data
reg [3:0] data;

// Counter to keep track of the current state
reg [1:0] cnt;

// Assign valid signal based on state
assign valid_out = (state == S0)? 1 : 0;

// Assign output based on state
always_comb begin
    case (state)
        S0: dout = data[3];
        S1: dout = data[2];
        S2: dout = data[1];
        S3: dout = data[0];
        default: dout = 1'bx;
    endcase
end

// FSM logic
always_comb begin
    case (state)
        S0: next_state = S1;
        S1: next_state = S2;
        S2: next_state = S3;
        S3: next_state = S0;
        default: next_state = S0;
    endcase
end

// Sequential logic
always_ff @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset state and counter
        state <= S0;
        cnt <= 2'b00;
        data <= 4'b0000;
    end else begin
        // Update state and counter
        state <= next_state;
        cnt <= (state == S3)? 2'b00 : cnt + 1;
        // Load parallel input data into data register
        if (state == S0) begin
            data <= d;
        end
    end
end

endmodule
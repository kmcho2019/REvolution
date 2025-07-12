module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

// One-hot encoded states (12 states)
reg [11:0] state;

// Next state logic
wire [11:0] next_state = {state[10:0], state[11]};

// Output encoding
always @(*) begin
    case (1'b1)
        state[0]:  out = 4'd0;
        state[1]:  out = 4'd1;
        state[2]:  out = 4'd2;
        state[3]:  out = 4'd3;
        state[4]:  out = 4'd4;
        state[5]:  out = 4'd5;
        state[6]:  out = 4'd6;
        state[7]:  out = 4'd7;
        state[8]:  out = 4'd8;
        state[9]:  out = 4'd9;
        state[10]: out = 4'd10;
        state[11]: out = 4'd11;
        default:  out = 4'd0;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Parallel load state 0 (one-hot)
        state <= 12'b0000_0000_0001;
    end else if (valid_count) begin
        // Rotate the one-hot bit
        state <= next_state;
    end
    // Else hold current state
end

endmodule
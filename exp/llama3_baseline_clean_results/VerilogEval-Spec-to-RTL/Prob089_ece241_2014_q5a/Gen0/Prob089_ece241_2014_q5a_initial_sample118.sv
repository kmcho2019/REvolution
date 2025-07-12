module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

reg [31:0] acc; // accumulated bits
reg [31:0] acc_new; // new accumulated bits
reg carry; // carry bit
reg carry_new; // new carry bit
reg [4:0] state; // state of the machine (0: idle, 1: convert)
reg [4:0] state_new; // new state of the machine
reg [4:0] count; // counter to keep track of the number of bits
reg [4:0] count_new; // new counter

always @(*) begin
    state_new = state;
    acc_new = acc;
    carry_new = carry;
    count_new = count;
    
    case (state)
        5'b00000: // idle state
            begin
                if (~areset) begin // reset is released
                    state_new = 5'b00001; // transition to convert state
                    acc_new = 0; // reset accumulated bits
                    carry_new = 0; // reset carry bit
                    count_new = 0; // reset counter
                end
            end
        5'b00001: // convert state
            begin
                if (areset) begin // reset is asserted
                    state_new = 5'b00000; // transition to idle state
                end else begin
                    acc_new = {acc[30:0], x}; // shift accumulated bits to the left and add new input bit
                    if (x) begin
                        carry_new = 1; // set carry bit if current bit is 1
                    end
                    count_new = count + 1; // increment counter
                end
            end
        default: ;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 5'b00000; // reset state to idle
        acc <= 0; // reset accumulated bits
        carry <= 0; // reset carry bit
        count <= 0; // reset counter
    end else begin
        state <= state_new;
        acc <= acc_new;
        carry <= carry_new;
        count <= count_new;
    end
end

assign z = (state == 5'b00001) ? ((acc[31] ^ carry) ? 1'b1 : 1'b0) : 1'b0;

endmodule
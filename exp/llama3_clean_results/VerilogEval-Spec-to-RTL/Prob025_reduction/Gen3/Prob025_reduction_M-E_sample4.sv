// Module to calculate the even parity bit for an 8-bit input byte using a shift register-based approach
module TopModule(
    input  clk,      // clock signal
    input  rst,      // reset signal
    input  [7:0] in, // 8-bit input byte
    output parity    // 1-bit output for even parity
);

reg [7:0] shift_reg; // 8-bit shift register
reg [2:0] counter;  // 3-bit counter to track the number of bits shifted
reg parity_bit;     // 1-bit parity register

// FSM states
enum logic [1:0] {IDLE, SHIFTING} state, next_state;

// Sequential logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        counter <= 0;
        shift_reg <= 0;
        parity_bit <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (in!= 0) begin // input is valid
                    state <= SHIFTING;
                    shift_reg <= in;
                    counter <= 1;
                end else begin
                    state <= IDLE;
                end
            end
            SHIFTING: begin
                if (counter < 8) begin
                    shift_reg <= {shift_reg[6:0], 0}; // shift left
                    parity_bit <= parity_bit ^ shift_reg[7]; // update parity bit
                    counter <= counter + 1;
                end else begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

// Combinational logic
assign parity = parity_bit;

endmodule
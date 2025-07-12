module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 3 bits to represent 8 states
reg disc_reg, flag_reg, err_reg;
reg [2:0] next_state;

// Define the states
localparam IDLE = 3'b000;
localparam ONE = 3'b001;
localparam TWO = 3'b010;
localparam THREE = 3'b011;
localparam FOUR = 3'b100;
localparam FIVE = 3'b101;
localparam SIX = 3'b110;
localparam SEVEN = 3'b111;

// Combinational logic for next state and output signals
always @(*) begin
    case (state)
        IDLE: begin
            if (in) next_state = ONE;
            else next_state = IDLE;
        end
        ONE: begin
            if (in) next_state = TWO;
            else next_state = IDLE;
        end
        TWO: begin
            if (in) next_state = THREE;
            else next_state = IDLE;
        end
        THREE: begin
            if (in) next_state = FOUR;
            else next_state = IDLE;
        end
        FOUR: begin
            if (in) next_state = FIVE;
            else next_state = IDLE;
        end
        FIVE: begin
            if (in) next_state = SIX;
            else begin
                next_state = IDLE;
                disc_reg = 1;
            end
        end
        SIX: begin
            if (in) begin
                next_state = SEVEN;
                err_reg = 1;
            end else begin
                next_state = IDLE;
                flag_reg = 1;
            end
        end
        SEVEN: begin
            if (~in) next_state = IDLE;
            else begin
                next_state = SEVEN;
                err_reg = 1;
            end
        end
    endcase
end

// Sequential logic for state and output signal registers
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        state <= next_state;
        disc_reg <= (state == FIVE && ~in)? 1 : 0;
        flag_reg <= (state == SIX && ~in)? 1 : 0;
        err_reg <= (state == SEVEN || (state == SIX && in))? 1 : 0;
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule
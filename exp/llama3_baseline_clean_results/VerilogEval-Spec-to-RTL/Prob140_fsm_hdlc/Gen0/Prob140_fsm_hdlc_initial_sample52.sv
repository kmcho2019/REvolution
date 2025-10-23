module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

// States for the FSM
// Idle: Initial state or after seeing a 0
// Count1: Counting consecutive 1s
// Flag: Seen 6 consecutive 1s, expecting a 0 for flag
// Disc: Seen 5 consecutive 1s, expecting a 0 to discard
// Error: Seen 7 or more consecutive 1s
enum logic [2:0] {
    Idle,
    Count1,
    Count2,
    Count3,
    Count4,
    Count5,
    Count6,
    Disc,
    Flag,
    Error
} state, next_state;

// Output signals
logic disc_out;
logic flag_out;
logic err_out;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        disc_out <= 1'b0;
        flag_out <= 1'b0;
        err_out <= 1'b0;
    end else begin
        state <= next_state;
        disc_out <= 1'b0;
        flag_out <= 1'b0;
        err_out <= 1'b0;
        
        case (state)
            Flag: flag_out <= 1'b1;
            Disc: disc_out <= 1'b1;
            Error: err_out <= 1'b1;
        endcase
    end
end

// Combinatorial logic for next state and output
always_comb begin
    next_state = state;
    case (state)
        Idle: begin
            if (in) next_state = Count1;
        end
        Count1: begin
            if (in) next_state = Count2;
            else next_state = Idle;
        end
        Count2: begin
            if (in) next_state = Count3;
            else next_state = Idle;
        end
        Count3: begin
            if (in) next_state = Count4;
            else next_state = Idle;
        end
        Count4: begin
            if (in) next_state = Count5;
            else next_state = Idle;
        end
        Count5: begin
            if (in) next_state = Count6;
            else next_state = Disc;
        end
        Count6: begin
            if (in) next_state = Error;
            else next_state = Flag;
        end
        Disc: begin
            if (in) next_state = Error;
            else next_state = Idle;
        end
        Flag: begin
            next_state = Idle;
        end
        Error: begin
            if (!in) next_state = Idle;
        end
    endcase
end

// Assign output signals
assign disc = disc_out;
assign flag = flag_out;
assign err = err_out;

endmodule
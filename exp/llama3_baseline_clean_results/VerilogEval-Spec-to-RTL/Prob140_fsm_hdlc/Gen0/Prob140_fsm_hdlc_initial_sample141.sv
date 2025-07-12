module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

// Define the states of the finite state machine
enum logic [2:0] {
    Idle = 3'b000,
    Ones = 3'b001,
    FiveOnes = 3'b010,
    Flag = 3'b011,
    Error = 3'b100
} state, nextState;

// Output signals
logic disc_out;
logic flag_out;
logic err_out;

// Combinational logic to determine the next state
always_comb begin
    case (state)
        Idle: begin
            if (in) begin
                nextState = Ones;
            end else begin
                nextState = Idle;
            end
        end
        Ones: begin
            if (in) begin
                if (&{4{1'b1}} == {4{in}}) begin // checking 4 consecutive ones
                    nextState = FiveOnes;
                end else begin
                    nextState = Ones;
                end
            end else begin
                nextState = Idle;
            end
        end
        FiveOnes: begin
            if (in) begin
                nextState = Flag;
            end else begin
                nextState = Idle;
            end
        end
        Flag: begin
            if (in) begin
                nextState = Error;
            end else begin
                nextState = Idle;
            end
        end
        Error: begin
            if (!in) begin
                nextState = Idle;
            end else begin
                nextState = Error;
            end
        end
        default: begin
            nextState = Idle;
        end
    endcase
end

// Output logic
always_comb begin
    case (state)
        FiveOnes: begin
            disc_out = in;
            flag_out = 1'b0;
            err_out = 1'b0;
        end
        Flag: begin
            disc_out = 1'b0;
            flag_out = 1'b1;
            err_out = 1'b0;
        end
        Error: begin
            disc_out = 1'b0;
            flag_out = 1'b0;
            err_out = 1'b1;
        end
        default: begin
            disc_out = 1'b0;
            flag_out = 1'b0;
            err_out = 1'b0;
        end
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        state <= nextState;
        disc <= disc_out;
        flag <= flag_out;
        err <= err_out;
    end
end

endmodule
module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

// Define the states
enum logic [2:0] { Idle, S1, S2, S3, Found } state, next_state;

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        if (state == Found) start_shifting <= 1;
        else start_shifting <= 0;
    end
end

// Combinational logic
always @(*) begin
    case (state)
        Idle: begin
            if (data == 1) next_state = S1;
            else next_state = Idle;
        end
        S1: begin
            if (data == 1) next_state = S2;
            else if (data == 0) next_state = Idle;
            else next_state = S1;
        end
        S2: begin
            if (data == 0) next_state = S3;
            else if (data == 1) next_state = S1;
            else next_state = S2;
        end
        S3: begin
            if (data == 1) next_state = Found;
            else if (data == 0) next_state = Idle;
            else next_state = S3;
        end
        Found: begin
            next_state = Found;
        end
    endcase
end

endmodule
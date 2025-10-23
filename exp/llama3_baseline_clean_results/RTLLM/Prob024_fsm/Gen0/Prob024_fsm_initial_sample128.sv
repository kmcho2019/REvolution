module fsm(
    input   logic   IN,
    input   logic   CLK,
    input   logic   RST,
    output  logic   MATCH
);

// Define states
localparam   S0 = 5'd0,
             S1 = 5'd1,
             S2 = 5'd2,
             S3 = 5'd3,
             S4 = 5'd4,
             S5 = 5'd5;

// Current state register
logic [4:0]   current_state, next_state;

// Combinational logic for next state
always_comb begin
    case (current_state)
        S0: begin
            if (IN) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (~IN) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (~IN) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S3: begin
            if (IN) begin
                next_state = S4;
            end else begin
                next_state = S1;
            end
        end
        S4: begin
            if (IN) begin
                next_state = S5;
            end else begin
                next_state = S1;
            end
        end
        S5: begin
            next_state = S0;
        end
        default: next_state = S0;
    endcase
end

// Sequential logic for current state
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0;
        MATCH <= 0;
    end else begin
        current_state <= next_state;
        if (current_state == S5 && IN) begin
            MATCH <= 1;
        end else begin
            MATCH <= 0;
        end
    end
end

endmodule
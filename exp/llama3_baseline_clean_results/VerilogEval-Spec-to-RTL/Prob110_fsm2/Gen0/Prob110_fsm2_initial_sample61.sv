module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

// Define states
typedef enum logic [0:0] {
    OFF,
    ON
} state_t;

// State register
state_t state;

// Combinational logic for next state
always_comb begin
    case(state)
        OFF: begin
            if(j) begin
                out = 0; // Since it's a Moore machine, output depends on state
            end else begin
                out = 0;
            end
        end
        ON: begin
            if(!k) begin
                out = 1;
            end else begin
                out = 1;
            end
        end
    endcase
end

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= OFF; // Reset to OFF state
    end else begin
        case(state)
            OFF: begin
                if(j) begin
                    state <= ON; // Transition to ON state if j is high
                end else begin
                    state <= OFF; // Stay in OFF state
                end
            end
            ON: begin
                if(k) begin
                    state <= OFF; // Transition to OFF state if k is high
                end else begin
                    state <= ON; // Stay in ON state
                end
            end
        endcase
    end
end

endmodule
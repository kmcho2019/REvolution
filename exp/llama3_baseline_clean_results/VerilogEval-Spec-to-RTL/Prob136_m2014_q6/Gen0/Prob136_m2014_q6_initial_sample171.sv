module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define all the states
typedef enum {
    A, B, C, D, E, F
} state_type;

// Initialize current_state
reg [2:0] current_state;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        current_state <= A;
    end else begin
        case(current_state)
            A: begin
                if(!w) current_state <= B;
                else current_state <= A;
            end
            B: begin
                if(!w) current_state <= C;
                else current_state <= D;
            end
            C: begin
                if(!w) current_state <= E;
                else current_state <= D;
            end
            D: begin
                if(!w) current_state <= F;
                else current_state <= A;
            end
            E: begin
                if(w) current_state <= D;
                else current_state <= E;
            end
            F: begin
                if(!w) current_state <= C;
                else current_state <= D;
            end
        endcase
    end
end

// Determine output 'z' based on the current state
always @(*) begin
    case(current_state)
        A, B, C, D: z = 0;
        E, F: z = 1;
    endcase
end

endmodule
module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states
parameter A = 4'b0000,
           B = 4'b0001,
           C = 4'b0010,
           D = 4'b0011,
           E = 4'b0100,
           F = 4'b0101;

reg [3:0] current_state;
reg [3:0] next_state;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case(current_state)
        A: begin
            if(w) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        B: begin
            if(w) begin
                next_state = D;
            end else begin
                next_state = C;
            end
        end
        C: begin
            if(w) begin
                next_state = D;
            end else begin
                next_state = E;
            end
        end
        D: begin
            if(w) begin
                next_state = A;
            end else begin
                next_state = F;
            end
        end
        E: begin
            if(w) begin
                next_state = D;
            end else begin
                next_state = E;
            end
        end
        F: begin
            if(w) begin
                next_state = D;
            end else begin
                next_state = C;
            end
        end
        default: next_state = A;
    endcase
end

// Determine the output z based on the current state
always @(*) begin
    case(current_state)
        A, B, C: z = 0;
        D, E, F: z = 1;
        default: z = 0;
    endcase
end

endmodule
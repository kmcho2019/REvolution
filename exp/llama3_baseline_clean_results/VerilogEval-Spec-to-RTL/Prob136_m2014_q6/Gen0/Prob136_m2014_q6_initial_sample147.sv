module TopModule(clk, reset, w, z);
    input clk, reset, w;
    output z;

    // Define the states
    parameter A = 3'b000;
    parameter B = 3'b001;
    parameter C = 3'b010;
    parameter D = 3'b011;
    parameter E = 3'b100;
    parameter F = 3'b101;

    // Declare the current state and next state variables
    reg [2:0] current_state;
    reg [2:0] next_state;

    // Combinational logic to determine the next state
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

    // Sequential logic to update the current state
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

    // Assign the output 'z' based on the current state
    always @(*) begin
        case(current_state)
            A: z = 0;
            B: z = 0;
            C: z = 0;
            D: z = 0;
            E: z = 1;
            F: z = 1;
            default: z = 0;
        endcase
    end

endmodule
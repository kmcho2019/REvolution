module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot state encoding
    localparam S_A = 4'b0001;
    localparam S_B = 4'b0010;
    localparam S_C = 4'b0100;
    localparam S_D = 4'b1000;
    
    reg [3:0] state;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= S_A;
        end else begin
            case (1'b1) // Synthesis will optimize this to parallel evaluation
                state[S_A]: 
                    state <= r[0] ? S_B : 
                            r[1] ? S_C : 
                            r[2] ? S_D : S_A;
                
                state[S_B]: 
                    state <= r[0] ? S_B : S_A;
                
                state[S_C]: 
                    state <= r[1] ? S_C : S_A;
                
                state[S_D]: 
                    state <= r[2] ? S_D : S_A;
                
                default: state <= S_A;
            endcase
        end
    end

    // Outputs are direct decodes of state (g0 for B, g1 for C, g2 for D)
    assign g = {state[S_D], state[S_C], state[S_B]};

endmodule
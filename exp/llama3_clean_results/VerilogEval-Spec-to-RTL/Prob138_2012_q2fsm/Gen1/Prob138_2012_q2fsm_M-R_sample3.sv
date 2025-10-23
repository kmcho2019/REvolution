module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// State codes
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Internal state signal
reg [2:0] current_state;

// State machine and output logic
always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        current_state <= A;
        z <= 0;
    end
    else
    begin
        case(current_state)
            A: 
            begin
                current_state <= (w) ? B : A;
                z <= 0;
            end
            B: 
            begin
                current_state <= (w) ? C : D;
                z <= 0;
            end
            C: 
            begin
                current_state <= (w) ? E : D;
                z <= 0;
            end
            D: 
            begin
                current_state <= (w) ? F : A;
                z <= 0;
            end
            E: 
            begin
                current_state <= (w) ? E : D;
                z <= 1;
            end
            F: 
            begin
                current_state <= (w) ? C : D;
                z <= 1;
            end
            default: 
            begin
                current_state <= A;
                z <= 0;
            end
        endcase
    end
end

endmodule
module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

// State definition
enum logic [1:0] {A = 2'b00, B = 2'b01, COUNTING = 2'b10, OUTPUT = 2'b11} state, nextState;

// Counter for w = 1 occurrences
logic [1:0] counter;

// Flag to indicate when to output z
logic output_z;

always_ff @(posedge clk) begin
    if(reset) begin
        state <= A;
        counter <= 2'b00;
        output_z <= 1'b0;
    end else begin
        case(state)
            A: begin
                if(s) begin
                    state <= B;
                    counter <= 2'b00;
                    output_z <= 1'b0;
                end else begin
                    state <= A;
                end
            end
            B: begin
                state <= COUNTING;
                counter <= counter + (w ? 1 : 0);
            end
            COUNTING: begin
                if(counter[0] == 1'b1) begin // This is the 2nd cycle
                    state <= COUNTING;
                    counter <= counter + (w ? 1 : 0);
                end else if(counter[0] == 1'b0 && counter[1] == 1'b1) begin // This is the 3rd cycle
                    state <= OUTPUT;
                    output_z <= (counter == 2'b10) ? 1'b1 : 1'b0;
                end else begin // First cycle
                    state <= COUNTING;
                    counter <= counter + (w ? 1 : 0);
                end
            end
            OUTPUT: begin
                state <= B;
                z <= output_z;
                output_z <= 1'b0;
                counter <= 2'b00;
            end
            default: state <= A;
        endcase
    end
end

// Output logic
always_comb begin
    case(state)
        OUTPUT: z = output_z;
        default: z = 1'b0;
    endcase
end

endmodule
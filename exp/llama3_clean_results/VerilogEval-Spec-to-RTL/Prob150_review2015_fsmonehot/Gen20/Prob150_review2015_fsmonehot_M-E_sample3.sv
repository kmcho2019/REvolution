// FSM_Controller module
module FSM_Controller (
    input  d,
    input  done_counting,
    input  ack,
    input  clk,
    input  rst,
    output [3:0] state
);

    reg [3:0] state_reg;
    assign state = state_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state_reg <= 4'b0000; // initial state
        end else begin
            case (state_reg)
                4'b0000: // S
                    if (d) begin
                        state_reg <= 4'b0001; // S1
                    end else begin
                        state_reg <= 4'b0000; // S
                    end
                4'b0001: // S1
                    if (d) begin
                        state_reg <= 4'b0010; // S11
                    end else begin
                        state_reg <= 4'b0000; // S
                    end
                4'b0010: // S11
                    if (d) begin
                        state_reg <= 4'b0010; // S11
                    end else begin
                        state_reg <= 4'b0011; // S110
                    end
                4'b0011: // S110
                    if (d) begin
                        state_reg <= 4'b0100; // B0
                    end else begin
                        state_reg <= 4'b0000; // S
                    end
                4'b0100: // B0
                    state_reg <= 4'b0101; // B1
                4'b0101: // B1
                    state_reg <= 4'b0110; // B2
                4'b0110: // B2
                    state_reg <= 4'b0111; // B3
                4'b0111: // B3
                    state_reg <= 4'b1000; // Count
                4'b1000: // Count
                    if (done_counting) begin
                        state_reg <= 4'b1001; // Wait
                    end else begin
                        state_reg <= 4'b1000; // Count
                    end
                4'b1001: // Wait
                    if (ack) begin
                        state_reg <= 4'b0000; // S
                    end else begin
                        state_reg <= 4'b1001; // Wait
                    end
                default: state_reg <= 4'b0000; // S
            endcase
        end
    end

endmodule

// Output_Decoder module
module Output_Decoder (
    input  [3:0] state,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    assign B3_next = (state == 4'b0111);
    assign S_next = (state == 4'b0000);
    assign S1_next = (state == 4'b0001);
    assign Count_next = (state == 4'b1000);
    assign Wait_next = (state == 4'b1001);
    assign done = (state == 4'b1001);
    assign counting = (state == 4'b1000);
    assign shift_ena = (state == 4'b0100) || (state == 4'b0101) || (state == 4'b0110) || (state == 4'b0111);

endmodule

// TopModule
module TopModule (
    input  d,
    input  done_counting,
    input  ack,
    input  clk,
    input  rst,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    wire [3:0] state;
    FSM_Controller fsm_controller (.d(d), .done_counting(done_counting), .ack(ack), .clk(clk), .rst(rst), .state(state));
    Output_Decoder output_decoder (.state(state), .B3_next(B3_next), .S_next(S_next), .S1_next(S1_next), .Count_next(Count_next), .Wait_next(Wait_next), .done(done), .counting(counting), .shift_ena(shift_ena));

endmodule
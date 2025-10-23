module TopModule(
    input  wire x,
    input  wire y,
    output wire z
);

    // Direct minimal implementation using bitwise XNOR (optimal for synthesis)
    assign z = x ~^ y;

    // Optional: Local parameter truth table for documentation or future reference
    // (Not used for logic but clarifies the mapping)
    localparam [3:0] truth_table = 4'b1001; // index = {x,y} from 00 to 11
    
    // Alternative combinational assignment (commented out)
    // reg z_case;
    // always @(*) begin
    //     case ({x,y})
    //         2'b00: z_case = 1'b1;
    //         2'b01: z_case = 1'b0;
    //         2'b10: z_case = 1'b0;
    //         2'b11: z_case = 1'b1;
    //         default: z_case = 1'b0;
    //     endcase
    // end

endmodule
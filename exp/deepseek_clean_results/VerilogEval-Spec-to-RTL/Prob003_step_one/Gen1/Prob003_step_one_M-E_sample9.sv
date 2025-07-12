module TopModule (
    output reg one
);

    // Define states (though we only need one)
    localparam HIGH = 1'b1;

    // State register
    reg state = HIGH;

    always @(*) begin
        case(state)
            HIGH: one = 1'b1;
            // No other states needed
        endcase
    end

endmodule
module TopModule(
    input  ring,
    input  vibrate_mode,
    output ringer,
    output motor
);

    assign ringer = ring && !vibrate_mode;
    assign motor  = ring && vibrate_mode;

    // Alternative implementation using a multiplexer
    // assign ringer = ring ? (vibrate_mode ? 0 : 1) : 0;
    // assign motor  = ring ? (vibrate_mode ? 1 : 0) : 0;

    // Using a 2-to-1 MUX
    assign ringer = ring ? (!vibrate_mode ? 1 : 0) : 0;
    assign motor  = ring ? (vibrate_mode ? 1 : 0) : 0;

    // The above can be rewritten for clarity using if-else statements
    // always @(ring, vibrate_mode) begin
    //     if (ring) begin
    //         if (vibrate_mode) begin
    //             ringer = 0;
    //             motor  = 1;
    //         end else begin
    //             ringer = 1;
    //             motor  = 0;
    //         end
    //     end else begin
    //         ringer = 0;
    //         motor  = 0;
    //     end
    // end

endmodule
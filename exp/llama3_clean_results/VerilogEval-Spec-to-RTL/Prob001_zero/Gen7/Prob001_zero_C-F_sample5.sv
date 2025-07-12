// TopModule: A simple module that always outputs a LOW.
module TopModule (
    output logic zero // Output port that is always LOW.
);
    // Directly assign the output 'zero' to 0, ensuring it remains LOW.
    assign zero = 1'b0;
endmodule